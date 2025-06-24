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
    Q_INVOKABLE QString read(const QString &filePath);
    Q_INVOKABLE bool exists(const QString &filePath);
    Q_INVOKABLE bool remove(const QString &dirPath, const int &cacheSize);
    Q_INVOKABLE void removeFile(const QString &filePath);
    Q_INVOKABLE QList<QString> sort(const QList<QString> &files);
    Q_INVOKABLE void removeThumbsWithoutProject(const QList<QString> &filePathes, const QString &dirPath);
    Q_INVOKABLE bool createDirectory(const QString &dirPath);
    Q_INVOKABLE QVariant getTemporaryFiles(const QString &dirPath);
    Q_INVOKABLE QString getMetadata(const QString &filePath);

private:
    QString getAbsolutePath(const QString &relativePath);
    QString getFileName(const QString &filePath);
    QString getParentDir(const QString &filePath);
    QString resolveFilePath(const QString &filePath);
};

#endif // FILEIO_H
