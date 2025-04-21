// fileio.cpp
#include "fileio.h"
#include <QDebug>
#include <QDateTime>

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

QString FileIO::read(const QString &filePath)
{
    QString data = "";
    QString resolvedPath = resolveFilePath(filePath);
    QFile file(resolvedPath);

    if (!file.exists()) {
        qWarning() << "File does not exist:" << resolvedPath;
        return data;
    }

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Failed to open file for reading:" << resolvedPath;
        return data;
    }

    QTextStream in(&file);
    data = in.readAll();
    file.close();
    return data;
}

bool FileIO::exists(const QString &filePath)
{
    QString resolvedPath = resolveFilePath(filePath);
    return QFile::exists(resolvedPath);
}

bool FileIO::remove(const QString &dirPath, const int &cacheSize)
{
    QString resolvedPath = resolveFilePath(dirPath);
    QDir dir(resolvedPath);

    if (!dir.exists()) {
        qWarning() << "Directory does not exist:" << resolvedPath;
        return false;
    }

    // Get all JSON files in the directory
    QStringList nameFilters;
    nameFilters << "*.json" << "*.JSON";
    dir.setNameFilters(nameFilters);
    dir.setFilter(QDir::Files);

    QFileInfoList fileList = dir.entryInfoList();

    // If there are 5 or less files, do nothing
    if (fileList.size() <= cacheSize) {
        qDebug() << "Not enough files to perform cleanup in:" << resolvedPath;
        return true;
    }

    // Sort files by last modified date (oldest first)
    std::sort(fileList.begin(), fileList.end(),
              [](const QFileInfo &a, const QFileInfo &b) {
                  return a.lastModified() < b.lastModified();
              });

    // Log what we're going to do
    qDebug() << "Found" << fileList.size() << "files in" << resolvedPath;
    qDebug() << "Files sorted by date (oldest first):";
    for (const QFileInfo &fileInfo : fileList) {
        qDebug() << "  " << fileInfo.fileName() << " - " << fileInfo.lastModified().toString();
    }

    // Keep track of success
    bool allSucceeded = true;

    // Remove all but the most recent file
    for (int i = 0; i < fileList.size() - cacheSize; ++i) {
        QString filePath = fileList.at(i).absoluteFilePath();
        qDebug() << "Removing old file:" << filePath;

        if (QFile::remove(filePath)) {
            qDebug() << "Successfully removed:" << filePath;
        } else {
            qWarning() << "Failed to remove:" << filePath;
            allSucceeded = false;
        }
    }

    return allSucceeded;
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
