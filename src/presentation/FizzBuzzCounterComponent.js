export default class FizzBuzzCounterComponent {
  constructor(service) {
    this._service = service;
    this._counter = 0;
    this._value = "FizzBuzz";
  }

  incrementEvent(e) {
    this._counter += 1;
    this._service.generate(this._counter).then(data => {
      this._value = data.value;
      this.render();
    });
  }

  decrementEvent(e) {
    this._counter === 0 ? (this._counter = 0) : (this._counter -= 1);
    this._service.generate(this._counter).then(data => {
      this._value = data.value;
      this.render();
    });
  }

  render() {
    const counter = `
              <div class="col-md-1">
                <button class="btn btn-primary" id="decrement">
                  -
                </button>
              </div>
              <div class="col-md-10">
                <h1 class="display-1 text-center">${this._value}</h1>
              </div>
              <div class="col-md-1">
                <button class="btn btn-primary" id="increment">
                  +
                </button>
              </div>
            `;

    document.querySelector("#app__counter").innerHTML = counter;
    document
      .querySelector("#increment")
      .addEventListener("click", this.incrementEvent.bind(this));
    document
      .querySelector("#decrement")
      .addEventListener("click", this.decrementEvent.bind(this));
  }
}
