# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $("form").submit(->
    if $("textarea").val().length > 0
      return true
    else
      return false
  )


  $(".checkbox").click(->
    $.ajax({
      url: "tasks/done/#{$(this).attr('id')}",
      type: "POST",
      data: {done: $(this).is(':checked')},
      dataType: 'html'
    })
    done = $(this).is(':checked')
    if done
      $(this).parent().parent().find(".content").css({ opacity: 0.6 })
      $(this).parent().parent().find(".date").hide()
    else
      $(this).parent().parent().find(".content").css({ opacity: 1 })
      $(this).parent().parent().find(".date").show()
  )

  $(".edit_image").click(->
    id = $(this).attr('id')
    $("##{id}.content").hide()
    $("##{id}.edit").show()

    $("##{id}.edit_image").hide()
    $("##{id}.delete_image").hide()
    $("##{id}.save_image").show()
    $("##{id}.cancel_image").show()
  )

  $(".save_image").click(->
    id = $(this).attr('id')
    text = $("##{id}.edit input").val()
    window.location = "/tasks/edit/#{id}/?text=#{text}"
  )

  $(".cancel_image").click(->
    id = $(this).attr('id')
    $("##{id}.content").show()
    $("##{id}.edit").hide()

    $("##{id}.edit_image").show()
    $("##{id}.delete_image").show()
    $("##{id}.save_image").hide()
    $("##{id}.cancel_image").hide()
  )



$(document).ready ->
  $(".timezone input")[0].value = new Date().getTimezoneOffset()
  $(".task").each ->
    done = $(this).find(".checkbox").is(':checked')
    if done
      $(this).find(".content").css({ opacity: 0.6 })
      $(this).find(".date").hide()
