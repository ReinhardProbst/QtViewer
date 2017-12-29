#pragma once

#include <iostream>

#include <QObject>

/*
 * Interface for handling selected filenames by QML dialogs
 * Offers three different solutions to interact from QML to C++
 * and offers signal forwarding within C++
 */

class FileNameCtrl : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString nominalLoad READ getNominalLoad WRITE setNominalLoad NOTIFY nominalChanged)

    QString _nominalLoadName;

public slots:
    void trendLoad(QString fn) {
        std::cout << "Selected trend file name to load: " << fn.toStdString() << std::endl;
        emit trendChanged(fn);
    }

public:
    Q_INVOKABLE void nominalSave(QString fn) {
        std::cout << "Selected nominal file name to save: " << fn.toStdString() << std::endl;
    }

    QString getNominalLoad() const { return _nominalLoadName; }
    void setNominalLoad(QString fn) {
        _nominalLoadName = fn;
        std::cout << "Selected nominal file name to load: " << _nominalLoadName.toStdString() << std::endl;
        emit nominalChanged(fn);
    }

signals:
    void nominalChanged(QString);
    void trendChanged(QString);
};
