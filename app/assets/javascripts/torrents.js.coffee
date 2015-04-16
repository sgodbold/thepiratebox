# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Global used to access variables from external places.
window.Application ||= {}

# Torrent Class
class Torrent
  constructor: (@url = 0) ->

handleInput = (id) ->
  input = document.getElementById(id).value
  document.getElementById(id).value = ''

  #TODO: add input validation

  if input != ''
    addTorrent(input)

  return

# Functions to interact with torrents table.
addTorrent = (url) ->
  $.ajax(
    url: "/torrents?url=" + url,
    type: "POST"
  )
  return

$(document).ready ->
  active = []
  done = []

  # Add onclicks
  $("#add-btn").click ->
    handleInput("add-input")

  $("#remove-btn").click ->
    removeTorrent()

  return
