#include <functional>
#include <iostream>

#include <QBasicTimer>
#include <QGuiApplication>
#include <QObject>
#include <QQmlApplicationEngine>
#include <QQmlProperty>
#include <QString>
#include <QVariant>

#include <QtQuick/QQuickView>

#include "filenames.hpp"
#include "frameprofileQPI.hpp"

template <typename V> class VTimer : public QObject {
    V _v;
    QBasicTimer _timer;

  public:
    explicit VTimer(int timeout, V v) : _v(v) {
        _timer.start(timeout, this);
        std::cout << "VTimer has id: " << _timer.timerId() << " and is active: " << _timer.isActive() << std::endl;
    }

    ~VTimer() {
        std::cout << "VTimer with id: " << _timer.timerId() << " will be stopped" << std::endl;
        _timer.stop();
    }

  protected:
    void timerEvent(QTimerEvent *event) final {
        if (event->timerId() == _timer.timerId()) {
            _v();
        }
    }
};

class CanvasFrameUpdate {
    const QVariantList y_pts_ok{0.29, 0.5, 0.5, 0.36};
    const QVariantList y_pts_nok{0.3, 0.5, 0.5, 0.35};
    const QColor color_ok{"#014D7B"};
    const QColor color_nok{"red"};

    QObject *_obj;
    unsigned _cnt;

  public:
    explicit CanvasFrameUpdate(QObject *obj) : _obj(obj), _cnt(0) {}

    ~CanvasFrameUpdate() {}

    void operator()() {
        if (++_cnt & 1) {
            QQmlProperty::write(_obj, "strokeColor", color_nok);
            QQmlProperty::write(_obj, "y_pts", y_pts_nok);
        } else {
            QQmlProperty::write(_obj, "strokeColor", color_ok);
            QQmlProperty::write(_obj, "y_pts", y_pts_ok);
        }

        QMetaObject::invokeMethod(_obj, "requestPaint");
    }
};

class QpiFrameUpdate {
    const std::array<qreal, 4> y_pts_ok{0.29, 0.5, 0.5, 0.36};
    const std::array<qreal, 4> y_pts_nok{0.3, 0.5, 0.5, 0.35};
    const QColor color_ok{"#014D7B"};
    const QColor color_nok{"red"};

    FrameProfileQPI *_obj;
    unsigned _cnt;

  public:
    explicit QpiFrameUpdate(FrameProfileQPI *obj) : _obj(obj), _cnt(0) {}

    ~QpiFrameUpdate() {}

    void operator()() {
        if (++_cnt & 1) {
            _obj->setColor(color_nok);
            _obj->updateYPoints(y_pts_nok);
        } else {
            _obj->setColor(color_ok);
            _obj->updateYPoints(y_pts_ok);
        }

        _obj->update();
    }
};

int main(int argc, char *argv[]) {
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    /*
     * Register C++ class as QML object
     */
    qmlRegisterType<FrameProfileQPI>("FrameProfileQPI", 1, 0, "FrameProfileQPI");

    /*
     * Load Qt/QML system
     */
    QQmlApplicationEngine engine;

    QStringList pathlist = engine.importPathList();
    for (auto a : pathlist)
        std::cout << a.toLocal8Bit().constData() << std::endl;

    engine.load(QUrl(QLatin1String("qrc:/qml/main.qml")));
    if (engine.rootObjects().isEmpty())
        exit(-1);

    /*
     * Get root object
     */
    QObject *rootObj = engine.rootObjects().first();
    if (rootObj)
        std::cout << "Got root object:" << rootObj->objectName().toStdString() << std::endl;
    else {
        std::cout << "No root object found" << std::endl;
        exit(-1);
    }

    /*
     * Set QML property directly
     */
    QObject *frameConfig = rootObj->findChild<QObject *>(QString{"frameConfig"});
    if (frameConfig)
        frameConfig->setProperty("text", "Configuration, set direct from C++");
    else
        std::cout << "No QML object frameConfig found" << std::endl;

    /*
     * Get QML property directly
     */
    QObject *frameProfileCanvas = rootObj->findChild<QObject *>(QString{"frameProfileCanvas"});
    if (frameProfileCanvas) {
        QVariant qv = QQmlProperty::read(frameProfileCanvas, "y_pts");
        std::cout << "frameProfileCanvas.y_pts is type: " << qv.typeName() << std::endl;
    } else
        std::cout << "No object frameProfileCanvas found" << std::endl;

    /*
     * Signal / slots
     */
    FileNames fn;

    QObject::connect(rootObj->findChild<QObject *>(QString{"fileNominal"}), SIGNAL(nominalName(const QString &)), &fn,
                     SLOT(nominalName(const QString &)));

    QObject::connect(rootObj->findChild<QObject *>(QString{"fileTrend"}), SIGNAL(trendName(const QString &)), &fn, SLOT(trendName(const QString &)));

    QObject::connect(&fn, &FileNames::trendNameChanged,
                     [&](const QString &fn) { std::cout << "Selected trend file name by lamda: " << fn.toStdString() << std::endl; });

    /*
     * Set QML property directly
     */
    QObject *frameProfileQPIText = rootObj->findChild<QObject *>(QString{"frameProfileQPIText"});
    if (frameProfileQPIText)
        QQmlProperty::write(frameProfileQPIText, "text", "Frame profile QPI, set direct from C++");
    else
        std::cout << "No object frameProfileQPIText found" << std::endl;

    /*
     * Get QML property directly, exposed as C++ class to QML and get it back from QML
     */
    FrameProfileQPI *fpQPI = rootObj->findChild<FrameProfileQPI *>(QString{"frameProfileQPI"});
    if (fpQPI) {
        std::cout << "Object frameProfileQPI found and castable" << std::endl;
    }

    /*
     * Set changes to QML property and update canvas
     */
    VTimer<CanvasFrameUpdate> vtimer_cfu(200, CanvasFrameUpdate(frameProfileCanvas));

    /*
     * Keep changes in C++ and update painter only
     */
    VTimer<QpiFrameUpdate> vtimer_qpi(200, QpiFrameUpdate(fpQPI));

    return app.exec();
}
