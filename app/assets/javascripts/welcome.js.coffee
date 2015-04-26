# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Global variables across whole page
window.Application ||= {}

refresh_torrent = (obj) ->
  id = obj['id']
  barId = "download-bar-" + id
  rowId = "row-" + id

  # Append new torrent if it doesn't exist
  if $('#'+rowId).length <= 0
    # Copy template row. Adjust tr id, progress bar id, and name
    row_copy = $(".active-torrent-template").clone().prop('id', rowId)
    $(row_copy).toggleClass("active-torrent-template", false)
    $(".torrent-header > i", row_copy).html(obj['name'])
    $(".torrent-body .progress .progress-bar", row_copy).prop('id', barId)
    $(row_copy).show()
    $("#active-torrent-table tbody:last").append(row_copy)

  # Update progress bar width
  val = (obj['percentDone']*100) + '%'
  $('#'+barId).prop("aria-valuenow", val)
  $('#'+barId).css("width", val)

  # Update progress bar color
  if obj['percentDone'] == 1
    $('#'+barId).toggleClass("progress-bar-info", false)
    $('#'+barId).toggleClass("progress-bar-success", true)

  return


info_update = (force=false) ->
  $.ajax(url: "/welcome/info_update").done (json) ->
    if json != 0 or force==true
      console.log("Change!")
      refresh_torrent torrent for torrent in json
    else
      console.log("no change..")
  return

info_init = () ->
  $.ajax(url: "/welcome/info_get").done (json) ->
    refresh_torrent torrent for torrent in json
  return

$(document).ready ->
  # Hide html template chunks
  $(".active-torrent-template").hide()

  # Add onclicks
  $("#update-btn").click ->
    info_update(true)

  # Initialize all data
  info_init()

  # Update loop
  setInterval(info_update, 1000)

  return
