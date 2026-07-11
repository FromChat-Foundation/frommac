package ru.fromchat.api.local.download

/** EXIF-oriented width/height from a local file (bounds read only; no full decode). */
internal expect fun readLocalImageDimensions(absolutePath: String): Pair<Int, Int>?
