# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery(document).ready ($) ->
    $('.dropdown-toggle').dropdown()


    # Toggle event time selectbox based on type
    toggle_selects = (type) ->
        if type is 'ONCE'
            $('#event_r_year, #event_r_month, #event_r_day, #event_r_hour').parent().parent().show()
            $('#event_r_wday').parent().parent().hide()
        else if type is 'DAILY'
            $('#event_r_hour').parent().parent().show()
            $('#event_r_year, #event_r_month, #event_r_day, #event_r_wday').parent().parent().hide()
        else if type is 'WEEKLY'
            $('#event_r_wday, #event_r_hour').parent().parent().show()
            $('#event_r_year, #event_r_month, #event_r_day').parent().parent().hide()
        else if type is 'MONTHLY'
            $('#event_r_day, #event_r_hour').parent().parent().show()
            $('#event_r_year, #event_r_month, #event_r_wday').parent().parent().hide()
        else if type is 'YEARLY'
            $('#event_r_month, #event_r_day, #event_r_hour').parent().parent().show()
            $('#event_r_year, #event_r_wday').parent().parent().hide()

    # on event type select change
    select_event_type = $('#event_event_type')
    select_event_type.change ->
        type = select_event_type.val()
        toggle_selects(type)

    # on form-loaded, automatically toggle reminder time form based on its type
    toggle_selects(select_event_type.val())


