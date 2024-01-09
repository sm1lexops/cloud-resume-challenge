const counter = document.querySelector(".counter-number");
async function updateCounter() {
    let response = await fetch("https://4r3vturzxat2vkxajjemqcyr3e0hlcyj.lambda-url.eu-central-1.on.aws/");
    let data = await response.json();
    counter.innerHTML = ` This page has <span class="emphasis">${data}</span> Views!`;
}

updateCounter();