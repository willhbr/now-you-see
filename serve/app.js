const MIN_SHOW = 3;

const loadLines = (two, index) => {
  var lines = two.makeGroup();

  for(var i in data[index]) {
    let pair = data[index][i];
    let amount = pair[0];
    let path = pair[1];
    if(amount < MIN_SHOW) {
      continue;
    }
    let comps = path.split('|');
    let to = comps[0],
        from = comps[1];
    locTo = locations[to];
    locFrom = locations[from];
    let line = two.makeLine(locTo.x, locTo.y, locFrom.x, locFrom.y);
    line.linewidth = Math.max(Math.min(8, amount / 10), 2);
    let h = (1 - Math.min(amount / 80, 1)) * 96 + 6; 
    line.stroke = 'hsla(' + h + ', 67%, 44%, 0.5)';
    line.cap = 'round';
    lines.add(line);
  }
  return lines;
}

const update = (two, index) => {
  if (index < 0) {
    index = 24 * 60 - 5;
  }
  index %= 24 * 60;
  newLines = loadLines(two, index);
  if(lines) two.remove(lines);
  lines = newLines;
  two.update();
  updateTime(index);
}

const updateTime = (index) => {
  let time = document.getElementById('time');
  let hour = Math.floor(index / 60);
  let minute = index % 60;
  if(minute < 10) minute = '0' + minute;
  time.innerHTML = "" + hour + ":" + minute;
}

let image = document.getElementById('image');
var elem = document.getElementById('canvas');
var two = new Two({ width: image.width, height: image.height }).appendTo(elem);
let slider = document.getElementById('slider');

let index = 540;

for(var i in locations) {
  let loc = locations[i];
  let y = -((loc.lat + 43.518939) / 0.008049) * two.height;
  let x = ((loc.long - 172.565585) / 0.022841) * two.width;
  loc.x = x;
  loc.y = y;
  let cir = two.makeCircle(x, y, 2, 2);
  cir.stroke = '#AD1457';
  cir.fill = '#AD1457';
}

two.update();

let lines = null;

document.onkeydown = (event) => {
  let newLines;
  if(event.keyIdentifier === 'Left') {
    index -= 5;
  } else if(event.keyIdentifier === 'Right') {
    index += 5;
  } else {
    return;
  }
  update(two, index);
  slider.value = index / 5;
}

slider.oninput = (event) => {
  index = slider.value * 5;
  update(two, index);
}

slider.value = index / 5;
update(two, index);
