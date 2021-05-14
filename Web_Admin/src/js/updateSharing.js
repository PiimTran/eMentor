console.log("fetched data: " + sharing);

let obj = {
  sharingId: "c3243cfb-5a1f-4ab3-ab65-c9287363b0e8",
  sharingName: "Java Web API",
  description: "Minimal Description",
  startTime: "2020-06-18T00:00:00",
  endTime: "2020-06-18T00:00:00",
  maximum: 6,
  price: 70,
  channelId: "111a9665-f8b2-48ac-a28f-20b65fc75996",
  imageUrl: null,
  isDisable: false,
  isApproved: false,
};

function postData(url = "", data = {}) {
  const response = fetch(url, {
    method: "PUT",
    mode: "cors",
    cache: "no-cache",
    credentials: "same-origin",
    headers: {
      "Content-type": "application/json",
      Accept: "application/json",
    },
    redirect: "follow",
    referrerPolicy: "no-referrer",
    body: JSON.stringify(data),
  })
    .then((response) => {
      console.log("status: " + response.status);
      if (response.status === 200) {
        localStorage.setItem(
          "message",
          JSON.stringify({ message: "Approve successfully!" })
        );
        window.location.href = "sharings.html";
      } else {
        localStorage.setItem(
          "message",
          JSON.stringify({ message: "Approve fail!" })
        );
        window.location.reload();
      }
      response.json();
    })
    .catch((error) => {
      console.log("error: ");
      localStorage.setItem(
        "message",
        JSON.stringify({ message: "Approve fail!" })
      );
      window.location.reload();
    });
}

document.getElementById("Approve").addEventListener("click", function () {
  sharing.isApproved = true;
  postData("https://ementorapi.azurewebsites.net/api/sharings", sharing);
});

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
