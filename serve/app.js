var elem = document.getElementById('canvas');
var two = new Two({ fullscreen: true }).appendTo(elem);

var circle = two.makeCircle(-70, 0, 50);
var rect = two.makeRectangle(70, 0, 100, 100);
circle.fill = '#FF8000';
circle.stroke = 'orangered';
rect.fill = 'rgba(0, 200, 255, 0.75)';
rect.stroke = '#1C75BC';

// Groups can take an array of shapes and/or groups.
var group = two.makeGroup(circle, rect);

// And have translation, rotation, scale like all shapes.
group.translation.set(two.width / 2, two.height / 2);
group.rotation = Math.PI;
group.scale = 0.75;

// You can also set the same properties a shape have.
group.linewidth = 7;

two.update();
