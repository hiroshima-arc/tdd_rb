export default class FizzBuzzApiService {
  get apiUrl() {
    return "https://tddrb.k2works.now.sh/api";
  }

  generate(number) {
    return new Promise((resolve, reject) => {
      fetch(`${this.apiUrl}/generate?number=${number}`)
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

  generateList(type) {
    return new Promise((resolve, reject) => {
      fetch(`${this.apiUrl}/generate_list?type=${type}&number=100`)
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
}
