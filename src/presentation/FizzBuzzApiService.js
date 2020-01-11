const fetch = require("node-fetch");
export default class FizzBuzzApiService {
  get apiUrl() {
    return "https://tddrb.k2works.now.sh/api";
  }

  _fetch(url) {
    return new Promise((resolve, reject) => {
      fetch(url)
        .then(response => {
          return response.json();
        })
        .then(json => {
          console.log(JSON.stringify(json));
          resolve(json);
        })
        .catch(err => {
          console.log(err);
          reject(err);
        });
    });
  }

  generate(number) {
    return this._fetch(`${this.apiUrl}/generate?number=${number}`);
  }

  generateList(type) {
    return this._fetch(`${this.apiUrl}/generate_list?type=${type}&number=100`);
  }
}
