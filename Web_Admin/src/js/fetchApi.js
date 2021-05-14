let table = document.querySelector("table");

function generateTableHead(table, data) {
    let thead = table.createTHead();
    let row = thead.insertRow();
    for (let key of data) {
        let th = document.createElement("th");
        let text = document.createTextNode(key);
        th.appendChild(text);
        row.appendChild(th);
    }
  }

function generateTable(table, data) {
    for (let element of data) {
      let row = table.insertRow();
      for (key in element) {
        let cell = row.insertCell();
        let text = document.createTextNode(element[key]);
        cell.appendChild(text);
      }
    }
  }

function fetchUser() {
    fetch('https://ementorapi.azurewebsites.net/api/users')
    .then(response => response.json())
    .then(data => {
        console.log(data);
        generateTableHead(table, Object.keys(data[0]));
        generateTable(table, data);
    });
    // .catch(response => console.log(response.status));
}

fetchUser();