(function() {
  this.App || (this.App = {});

  App.currentUser = function() {
    if ($('#user-data')) {
      return $('#user-data').data();
    } else {
      return;
    }
  }

  App.getMetaContent = function(name) {
    var metas = document.getElementsByTagName('meta');

    for (var i=0; i<metas.length; i++) {
      if (metas[i].getAttribute("name") == name) {
        return metas[i].getAttribute("content");
      }
    }

    return "";
  }

}).call(this);
