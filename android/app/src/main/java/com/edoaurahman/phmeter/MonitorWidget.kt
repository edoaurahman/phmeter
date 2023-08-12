package com.edoaurahman.phmeter

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * Implementation of App Widget functionality.
 */
class MonitorWidget : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId, widgetData)
        }
    }
}

internal fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int, widgetData: SharedPreferences) {
    // Construct the RemoteViews object
    val views = RemoteViews(context.packageName, R.layout.monitor_widget).apply {
        // Open App on Widget Click
        val pendingIntent = HomeWidgetLaunchIntent.getActivity(
            context,
            MainActivity::class.java)
        setOnClickPendingIntent(R.id.widget_container, pendingIntent)
        
        val suhu = widgetData.getString("suhu", null)
        val ph = widgetData.getString("ph", null)
        val ppm = widgetData.getString("ppm", null)

        setTextViewText(R.id.suhu, (suhu ?: "SUHU : 0"))
        setTextViewText(R.id.ph, (ph ?: "PH : 0"))
        setTextViewText(R.id.ppm, (ppm ?: "PPM : 0"))

        val refreshBackground = HomeWidgetBackgroundIntent.getBroadcast(
            context,
            Uri.parse("MonitorWidget://refresh")
        )
        setOnClickPendingIntent(R.id.btn_refresh, refreshBackground)
    }
    // Instruct the widget manager to update the widget
    appWidgetManager.updateAppWidget(appWidgetId, views)
}