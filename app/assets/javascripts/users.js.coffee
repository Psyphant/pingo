# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

@getLocation = ->
  success = (position) ->
    s = $("#status")
    # im FF wird die Funktion scheinbar mehrfach aufgerufen - einmal reicht
    return  if s.hasClass("success")
    $("#coordFields").show()
    $("#locationFields").hide()
    $("#openLocationFields").show()
    $("#radiusField").show()
    s.text "Deine Position konnte ermittelt werden!"
    s.addClass "success"
    $("#user_latitude").val position.coords.latitude
    $("#user_longitude").val position.coords.longitude
    navigator.geolocation.clearWatch watchId
    return
  error = (msg) ->
    $("#status").text = (if typeof msg is "string" then msg else "error")
    return
  if navigator.geolocation
    watchId = navigator.geolocation.getCurrentPosition(success, error)
  else
    $("#status").text = "Sorry your browser does not support geolocation."
  return

@getPositionManually = ->
  $("#locationFields").show()
  $("#openLocationFields").hide()
  $("#coordFields").hide()
  $("#radiusField").show()
  return

userFilter = (->
  sendFilter = ->
    skillFilter.toString() if skillFilter && skillFilter.isArray
    $.ajax
      type: "get"
      data:
        skill: skillFilter,
        city: cityFilter,
        name: nameFilter
      dataType: 'script'
    return

  #definitions
  cityFilter = null
  skillFilter = null
  nameFilter = null

  getFilter: (type) ->
    if type == "city"
      return cityFilter
    else if type == "skill"
      return skillFilter
    else if type == "name"
      return nameFilter
    return

  setFilter: (type, value) ->
    if type == "city"
      cityFilter = value
    else if type == "skill"
      skillFilter = value
    else if type == "name"
      nameFilter = value
    return sendFilter()

  removeFilter: (type, value) ->
    if type == "city"
      cityFilter = null
    else if type == "skill"
      skillFilter = null
    else if type == "name"
      nameFilter = null
    return sendFilter()
)()

$ ->
  $("body").delegate "#workers-filter .place-list a", "click", ->
    city = userFilter.getFilter("city")
    if city == @name
      userFilter.removeFilter("city", @name)
      $(@).toggleClass "active"
    else
      $("li a[name="+city+"]").toggleClass "active"
      userFilter.setFilter("city", @name)
      $(@).toggleClass "active"
    false

  $("body").delegate "#workers-filter .tag-list a", "click", ->
    skill = userFilter.getFilter("skill")
    if skill == null #kein Skillfilter gesetzt
        userFilter.setFilter("skill", @name)
        $(@).addClass "active"
    else
      index = skill.indexOf(@name)
      if skill == @name #Skill ist schon vorhanden
        userFilter.removeFilter("skill", skill)
        $(@).removeClass "active"
      else if index > -1 #der Skill im Array schon vor? -> ja
        skill.splice(index, 1) #lösche den Skill raus
        userFilter.setFilter("skill", skill) #setze ihn neu
        $(@).removeClass "active"
      else
        skill = new Array(skill, @name)
        userFilter.setFilter("skill", skill)
        $(@).addClass "active"
    false

  $("#users-search #name-search-button").click ->
    name = userFilter.getFilter("name")
    searchValue = $('#users-search #name').val()
    if name != searchValue
      userFilter.setFilter("name", searchValue)

  $("#users-search #name").keyup ->
    $.ajax(
      type: "get"
      data:
        city_filter: @value,
        skill_filter: @value,
    ).success (data) ->
      newFilterContent = $(data).find("#workers-filter")
      $("#city-filter").html newFilterContent.find("#city-filter").html()
      $("#skill-filter").html newFilterContent.find("#skill-filter").html()
    false
  return
