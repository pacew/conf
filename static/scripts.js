function onSignIn(googleUser) {
  var profile = googleUser.getBasicProfile();
  var id_token = googleUser.getAuthResponse().id_token;

  if (0) {
    $.ajax({
      method: "POST",
      url: "setid.php",
      data: { id: id_token }
    }).done(function (msg) {
      console.log ("setid done", msg);
    });
  }

  url = "/setid.php?id=" + encodeURI(id_token);
  window.location = url;
}

$(function () {
});
