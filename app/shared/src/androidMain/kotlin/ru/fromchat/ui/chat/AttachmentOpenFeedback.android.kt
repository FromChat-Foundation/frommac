package ru.fromchat.ui.chat

import android.widget.Toast
import com.pr0gramm3r101.utils.UtilsLibrary

internal actual fun showAttachmentOpenFailed(message: String) {
    Toast.makeText(UtilsLibrary.context, message, Toast.LENGTH_SHORT).show()
}
