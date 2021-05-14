let table = document.querySelector("table");
var sharing = {};

function generateTableHead(table, data) {
  let thead = table.createTHead();
  let row = thead.insertRow();
  let th = document.createElement("th");
  let text = document.createTextNode("Field");
  th.appendChild(text);
  row.appendChild(th);
  th = document.createElement("th");
  text = document.createTextNode("Detail");
  th.appendChild(text);
  row.appendChild(th);
}

function generateTable(table, data) {
  sharing = data[0];

  for (key in data[0]) {
    let row = table.insertRow();
    let cell = row.insertCell();
    let text = document.createTextNode(key);
    cell.appendChild(text);

    cell = row.insertCell();
    text = document.createTextNode(data[0][key]);
    cell.appendChild(text);
  }
}

function fetchSharings() {
  let tmp = window.location.search;
  let id = tmp.substr(4, tmp.length);
  fetch("https://ementorapi.azurewebsites.net/api/sharings/" + id)
    .then((response) => response.json())
    .then((data) => {
      generateTableHead(table, Object.keys(data[0]));
      generateTable(table, data);
    });

  localStorage.clear();
  // .catch(response => console.log(response.status));
}

fetchSharings();
