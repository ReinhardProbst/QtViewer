#pragma once

#include <iostream>

#include <QObject>

class FileNames : public QObject
{
    Q_OBJECT

public slots:
    void nominalName(const QString &fn) {
        std::cout << "Selected nominal file name: " << fn.toStdString() << std::endl;
    }

    void trendName(const QString &fn) {
        std::cout << "Selected trend file name: " << fn.toStdString() << std::endl;
        emit trendNameChanged(fn);
    }

signals:
    void trendNameChanged(const QString &fn);
};
