// fileio.cpp
#include "fileio.h"
#include <QDebug>

FileIO::FileIO(QObject *parent) : QObject(parent)
{
}

QString FileIO::resolveFilePath(const QString &filePath)
{
    QUrl url(filePath);
    if (url.isLocalFile()) {
        return url.toLocalFile();
    }
    return filePath;
}

bool FileIO::write(const QString &filePath, const QString &data)
{
    QString resolvedPath = resolveFilePath(filePath);
    QFile file(resolvedPath);

    // Create parent directory if it doesn't exist
    QFileInfo fileInfo(resolvedPath);
    QDir dir = fileInfo.dir();
    if (!dir.exists()) {
        if (!dir.mkpath(".")) {
            qWarning() << "Failed to create directory:" << dir.path();
            return false;
        }
    }

    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qWarning() << "Failed to open file for writing:" << resolvedPath << "Error:" << file.errorString();
        return false;
    }

    QTextStream out(&file);
    out << data;
    file.close();

    qDebug() << "Successfully wrote to file:" << resolvedPath;
    return true;
}

bool FileIO::read(const QString &filePath, QString &data)
{
    QString resolvedPath = resolveFilePath(filePath);
    QFile file(resolvedPath);

    if (!file.exists()) {
        qWarning() << "File does not exist:" << resolvedPath;
        return false;
    }

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Failed to open file for reading:" << resolvedPath;
        return false;
    }

    QTextStream in(&file);
    data = in.readAll();
    file.close();

    return true;
}

bool FileIO::exists(const QString &filePath)
{
    QString resolvedPath = resolveFilePath(filePath);
    return QFile::exists(resolvedPath);
}

bool FileIO::createDirectory(const QString &dirPath)
{
    QString resolvedPath = resolveFilePath(dirPath);
    QDir dir(resolvedPath);

    if (dir.exists()) {
        return true;
    }

    return dir.mkpath(".");
}

QString FileIO::getParentDir(const QString &filePath)
{
    QString resolvedPath = resolveFilePath(filePath);
    QFileInfo fileInfo(resolvedPath);
    return fileInfo.dir().path();
}

QString FileIO::getFileName(const QString &filePath)
{
    QString resolvedPath = resolveFilePath(filePath);
    QFileInfo fileInfo(resolvedPath);
    return fileInfo.fileName();
}

QString FileIO::getAbsolutePath(const QString &relativePath)
{
    QDir dir;
    return dir.absoluteFilePath(relativePath);
}
