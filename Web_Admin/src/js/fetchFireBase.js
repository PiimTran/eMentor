let table = document.querySelector("table");
let fetchedData = {};

function generateTableHead(table, data) {
  let thead = table.createTHead();
  let row = thead.insertRow();
  for (let key in data["fields"]) {
    let th = document.createElement("th");
    let text = document.createTextNode(key);
    th.appendChild(text);
    row.appendChild(th);
  }
}

function generateTable(table, data) {
  for (let element of data) {
    let row = table.insertRow();
    for (key in element["fields"]) {
      for (field in element["fields"][key]) {
        let cell = row.insertCell();
        let text = document.createTextNode(element["fields"][key][field]);
        cell.appendChild(text);
      }
    }

    let cell = row.insertCell();
    let a = document.createElement("a");
    a.href = "sharingdetail.html?id=" + element["sharingId"];

    btn = document.createElement("BUTTON");
    btn.innerHTML = "Edit";
    btn.classList.add("btn", "btn-primary");
    btn.onclick = function (event) {
      localStorage.setItem("id", element["sharingId"]);
    };

    a.append(btn);
    cell.appendChild(a);
  }
}

function fetchSharings() {
  fetch(
    "https://firestore.googleapis.com/v1/projects/flutter-chat-ba7c2/databases/(default)/documents/channel/IZYCyyKqf7nk3XFHvm3i/sharing"
  )
    .then((response) => response.json())
    .then((data) => {
      console.log(data["documents"]);
      generateTableHead(table, data["documents"][0]);
      generateTable(table, data["documents"]);
    });
  // .catch(response => console.log(response.status));
}

fetchSharings();

function fetchData() {
  let tmp = window.location.pathname;
  let url = tmp.substr(0, tmp.lastIndexOf("."));
  console.log("url " + url);

  fetch("https://ementorapi.azurewebsites.net/api" + url)
    .then((response) => response.json())
    .then((data) => {
      console.log(data);
      generateTableHead(table, Object.keys(data[0]));
      generateTable(table, data);
    });
  // .catch(response => console.log(response.status));
}

// fetchData();

function getMessage() {
  if (localStorage.getItem("message") !== null) {
    let alert = document.getElementById("alert");
    // alert.innerHTML = JSON.parse(localStorage.getItem("message")).message;
    alert.classList.add("show");
    // const completedButton = document.createElement("button");
    alert.innerHTML =
      JSON.parse(localStorage.getItem("message")).message +
      ' <button type="button" class="close" data-dismiss="alert" aria-label="Close"> <span aria-hidden="true">&times;</span></button>';
    // alert.appendChild(completedButton);
    localStorage.clear();
  } else {
  }
}

getMessage();

function getId() {}
