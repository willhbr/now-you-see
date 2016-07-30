let image = document.getElementById('image');
var elem = document.getElementById('canvas');
var two = new Two({ width: image.width, height: image.height }).appendTo(elem);

let index = 1000;

for(var i in locations) {
  let loc = locations[i];
  let y = ((loc.lat + 43.51) / 0.03) * two.height;
  let x = ((loc.long - 172.57) / 0.02) * two.width;
  two.makeCircle(x, -y, 2, 2);
}

console.log(data);

for(var i in data[index]) {
  
}

two.update();
