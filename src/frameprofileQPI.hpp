#pragma once

#include <iostream>
#include <cstring>

#include <QtQuick/QQuickPaintedItem>
#include <QColor>
#include <QPoint>
#include <QPainter>

class FrameProfileQPI : public QQuickPaintedItem
{
    Q_OBJECT

    Q_PROPERTY(QString name READ getName WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QColor color READ getColor WRITE setColor NOTIFY colorChanged)

    constexpr static unsigned max_points = 4;

    QString m_name;
    QColor m_color;
    const std::array<qreal, max_points> _x{0.10, 0.15, 0.90, 0.15};
    std::array<qreal, max_points> _y{0.29, 0.5, 0.5, 0.36};

public:
        FrameProfileQPI(QQuickItem *parent = 0) : QQuickPaintedItem(parent), m_name("Default profile"), m_color("#014D7B") {}
        ~FrameProfileQPI(){};

        QString getName() const { return m_name; }
        void setName(const QString& name) { m_name = name; }

        QColor getColor() const { return m_color; }
        void setColor(const QColor& color) { m_color = color; }

        void updateYPoints(const std::array<qreal, max_points>& y) { _y = y; }

        void draw_profile(QPainter *painter, int width, int height){
            painter->setPen(QPen(m_color, 1));
            painter->setBrush(QBrush(QColor("#BEEDF5")));

            QPointF points[max_points]{};
            for (unsigned i = 0; i < max_points; ++i) {
                points[i].setX(_x[i]*width);
                points[i].setY(_y[i]*height-10);
            }

            painter->drawConvexPolygon(&points[0], max_points);
        }

        void draw_grid(QPainter *painter, int width, int height){
            painter->setPen(QPen(QColor("black"), 1));

            qreal xmax = 0.91*width;
            qreal xmin = 0.09*width;
            qreal ymax = 0.51*height-10;
            qreal ymin = 0.28*height-10;

            qreal xstep = (xmax - xmin) / 10;
            qreal ystep = (ymax - ymin) / 5;

            QPainterPath path;
            for (unsigned i = 0; i <= 10; ++i) {
                path.moveTo(xmin + i * xstep, ymin);
                path.lineTo(xmin + i * xstep, ymax);
            }
            for (unsigned i = 0; i <= 5; ++i) {
                path.moveTo(xmin, ymin + i * ystep);
                path.lineTo(xmax, ymin + i * ystep);
            }
            path.closeSubpath();
            painter->drawPath(path);
        }

        void paint(QPainter *painter) final {
            int width = boundingRect().width();
            int height = boundingRect().height();

            draw_profile(painter, width, height);
            draw_grid(painter, width, height);
        }

signals:
    void nameChanged(QString);
    void colorChanged(QColor);
};
