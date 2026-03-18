package com.phoenix.phoenix_app

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class PhoenixWidgetSmall : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_small)

            val done = widgetData.getInt("phoenix_protocol_done", 0)
            val levelNum = widgetData.getInt("phoenix_level_number", 1)
            val steps = widgetData.getInt("phoenix_steps", 0)
            val nextStep = widgetData.getString("phoenix_next_step", "") ?: ""

            views.setTextViewText(R.id.tv_level, "LV $levelNum")
            views.setTextViewText(R.id.tv_protocol, "$done/6")
            views.setTextViewText(R.id.tv_steps, "$steps passi")
            views.setTextViewText(R.id.tv_next, nextStep)

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}

class PhoenixWidgetLarge : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_large)

            val done = widgetData.getInt("phoenix_protocol_done", 0)
            val levelNum = widgetData.getInt("phoenix_level_number", 1)
            val steps = widgetData.getInt("phoenix_steps", 0)
            val hrvMs = widgetData.getFloat("phoenix_hrv_ms", 0f)
            val recovery = widgetData.getString("phoenix_recovery", "") ?: ""
            val sleepSummary = widgetData.getString("phoenix_sleep_summary", "") ?: ""
            val nextStep = widgetData.getString("phoenix_next_step", "") ?: ""

            val sleepDone = widgetData.getBoolean("phoenix_sleep_done", false)
            val trainingDone = widgetData.getBoolean("phoenix_training_done", false)
            val fastingDone = widgetData.getBoolean("phoenix_fasting_done", false)
            val coldDone = widgetData.getBoolean("phoenix_cold_done", false)
            val meditationDone = widgetData.getBoolean("phoenix_meditation_done", false)

            views.setTextViewText(R.id.tv_level, "LV $levelNum")
            views.setTextViewText(R.id.tv_protocol, "Protocollo: $done/6")
            views.setTextViewText(R.id.tv_steps, "$steps passi")
            views.setTextViewText(R.id.tv_next, nextStep)
            views.setTextViewText(R.id.tv_sleep_summary, sleepSummary)

            if (hrvMs > 0) views.setTextViewText(R.id.tv_hrv, "HRV ${hrvMs.toInt()}ms")
            if (recovery.isNotEmpty()) views.setTextViewText(R.id.tv_recovery, recovery)

            // Protocol items
            fun check(done: Boolean) = if (done) "✓" else "○"
            views.setTextViewText(R.id.tv_sleep, "${check(sleepDone)} Sonno")
            views.setTextViewText(R.id.tv_training, "${check(trainingDone)} Training")
            views.setTextViewText(R.id.tv_fasting, "${check(fastingDone)} Digiuno")
            views.setTextViewText(R.id.tv_cold, "${check(coldDone)} Freddo")
            views.setTextViewText(R.id.tv_meditation, "${check(meditationDone)} Meditazione")

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
