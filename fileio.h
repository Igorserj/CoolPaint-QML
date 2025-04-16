// fileio.h
#ifndef FILEIO_H
#define FILEIO_H

#include <QObject>
#include <QFile>
#include <QDir>
#include <QUrl>
#include <QTextStream>
#include <QFileInfo>

class FileIO : public QObject
{
    Q_OBJECT

public:
    explicit FileIO(QObject *parent = nullptr);

    Q_INVOKABLE bool write(const QString &filePath, const QString &data);
    Q_INVOKABLE bool read(const QString &filePath, QString &data);
    Q_INVOKABLE bool exists(const QString &filePath);
    Q_INVOKABLE bool createDirectory(const QString &dirPath);
    Q_INVOKABLE QString getParentDir(const QString &filePath);
    Q_INVOKABLE QString getFileName(const QString &filePath);
    Q_INVOKABLE QString getAbsolutePath(const QString &relativePath);

private:
    QString resolveFilePath(const QString &filePath);
};

#endif // FILEIO_H
