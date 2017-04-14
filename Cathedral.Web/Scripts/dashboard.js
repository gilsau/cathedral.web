$(document).ready(function () {

    //complete pre-walk
    $('.preWalkComplete').click(function () {
        var id = $(this).attr('data-id');


    });

    $('#preWalksBox .squareOverlay').css('display', 'none');

    //open right box
    $('#rightBoxToggleLink').click(function () {
        var link = $(this);
        var box = $('#rightBox');
        var arrow = link.find('.glyphicon-arrow-left,.glyphicon-arrow-right');

        box.toggle();

        if (arrow.hasClass('glyphicon-arrow-left')) {
            arrow.removeClass('glyphicon-arrow-left');
            arrow.addClass('glyphicon-arrow-right');
        }
        else if (arrow.hasClass('glyphicon-arrow-right')) {
            arrow.removeClass('glyphicon-arrow-right');
            arrow.addClass('glyphicon-arrow-left');
        }
    });
});