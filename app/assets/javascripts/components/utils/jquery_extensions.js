$.fn.extend({
    is_fully_in_view: function() {
        var $window = $(window);

        var docViewTop = $window.scrollTop();
        var docViewBottom = docViewTop + $window.height();

        var elemTop = this.offset().top;
        var elemBottom = elemTop + this.height();

        return ((elemBottom <= docViewBottom) && (elemTop >= docViewTop));
    }
})