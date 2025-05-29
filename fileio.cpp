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
    QString resolvedPath = resolveFilePath(dirPath + "/tmp");
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
    QList<QString> projNames;

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
    for (const QFileInfo &fileInfo : std::as_const(fileList)) {
        projNames << fileInfo.baseName();
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

    resolvedPath = resolveFilePath(dirPath + "/thumbs");
    for (int i = 0; i < projNames.size() - cacheSize; ++i) {
        QString filePath = resolvedPath + "/" + projNames.at(i) + ".png";
        if (QFile::remove(filePath)) {
            qDebug() << "Successfully removed:" << filePath;
        } else {
            qWarning() << "Failed to remove:" << filePath;
            allSucceeded = false;
        }
    }
    return allSucceeded;
}
QList<QString> FileIO::sort(const QList<QString> &files) {
    QList<QString> validFiles;

    for (const QString &filePath : files) {
        QFile file(filePath);
        if (!file.exists()) {
            qDebug() << "File does not exist:" << filePath;
            continue;
        }

        QFileInfo info(filePath);
        info.refresh(); // Force refresh
        validFiles << filePath;
    }

    // Sort by filename if timestamps don't work
    std::sort(validFiles.begin(), validFiles.end(),
              [](const QString &a, const QString &b) {
                  QFileInfo infoA(a);
                  QFileInfo infoB(b);

                  // Try timestamp first
                  if (infoA.lastModified().isValid() && infoB.lastModified().isValid()) {
                      return infoA.lastModified() > infoB.lastModified();
                  }

                  // Fallback to filename
                  return infoA.fileName() < infoB.fileName();
              });

    return validFiles;
}

void FileIO::removeFile(const QString &filePath) {
    QString resolvedPath = resolveFilePath(filePath);
    QFile::remove(resolvedPath);
}

void FileIO::removeThumbsWithoutProject(const QList<QString> &filePathes, const QString &dirPath) {
    QList<QString> fileNames;
    QList<QString> removalFiles;
    QFileInfoList imagesInDir;
    QString resolvedPath = resolveFilePath(dirPath);
    QDir dir(resolvedPath);
    QStringList nameFilters;
    nameFilters << "*.png" << "*.PNG";
    dir.setNameFilters(nameFilters);
    dir.setFilter(QDir::Files);
    imagesInDir = dir.entryInfoList();

    for (const QString &filePath : filePathes) {
        QFile file(filePath);
        if (!file.exists()) {
            qDebug() << "File does not exist:" << filePath;
            continue;
        }
        QFileInfo info(filePath);
        info.refresh(); // Force refresh
        fileNames << info.baseName();
    }
    for (int i = 0; i < imagesInDir.size(); ++i) {
        bool fileExist = false;
        for (int j = 0; j < fileNames.size(); ++j) {
            if (imagesInDir.at(i).baseName() == fileNames.at(j)) {
                fileExist = true;
                break;
            }
        }
        if (!fileExist) {
            removalFiles << imagesInDir.at(i).absoluteFilePath();
        }
    }
    for (int i = 0; i < removalFiles.size(); ++i) {
        QString filePath = removalFiles.at(i);
        qDebug() << "Removing unlinked image:" << filePath;

        if (QFile::remove(filePath)) {
            qDebug() << "Successfully removed:" << filePath;
        } else {
            qWarning() << "Failed to remove:" << filePath;
        }
    }
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

QVariant FileIO::getTemporaryFiles(const QString &dirPath)
{
    QString resolvedPath = resolveFilePath(dirPath);
    QDir dir(resolvedPath);
    QFileInfoList fileList;
    QList<QString> fileNames;

    if (!dir.exists()) {
        qWarning() << "Directory does not exist:" << resolvedPath;
        return QVariant::fromValue(fileList);
    }

    // Get all JSON files in the directory
    QStringList nameFilters;
    nameFilters << "*.json" << "*.JSON";
    dir.setNameFilters(nameFilters);
    dir.setFilter(QDir::Files);
    fileList = dir.entryInfoList();
    std::sort(fileList.begin(), fileList.end(),
              [](const QFileInfo &a, const QFileInfo &b) {
                  return a.lastModified() > b.lastModified();
              });

    for (const QFileInfo &fileInfo : std::as_const(fileList)) {
        const QDateTime lastMod = fileInfo.lastModified();
        fileNames << "{\"name\":\"" +
                         fileInfo.baseName() +
                         "\" , \"date\":\"" +
                         lastMod.toString("dd.MM.yy") +
                         "\" , \"time\":\"" +
                         lastMod.toString("hh:mm:ss") +
                         "\" , \"path\":\"" +
                         fileInfo.absolutePath() +
                         "/" + fileInfo.fileName() + "\"}";
    }
    return QVariant::fromValue(fileNames);
}
