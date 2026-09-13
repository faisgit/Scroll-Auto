package com.faisalansari.scrollauto

import android.os.Build
import android.service.quicksettings.Tile
import android.service.quicksettings.TileService
import androidx.annotation.RequiresApi

@RequiresApi(Build.VERSION_CODES.N)
class AutoScrollTileService : TileService() {

    override fun onStartListening() {
        super.onStartListening()
        updateTileState()
    }

    override fun onClick() {
        super.onClick()
        val isRunning = AutoScrollService.toggleAutoScroll()
        updateTileState(isRunning)
    }

    private fun updateTileState(isRunning: Boolean = AutoScrollService.isAutoScrollRunning()) {
        val tile = qsTile ?: return
        if (isRunning) {
            tile.state = Tile.STATE_ACTIVE
            tile.label = "Auto Scroll: ON"
        } else {
            tile.state = Tile.STATE_INACTIVE
            tile.label = "Auto Scroll: OFF"
        }
        tile.updateTile()
    }
}
