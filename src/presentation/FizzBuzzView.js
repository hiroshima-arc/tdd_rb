import FizzBuzzCounterComponent from "./FizzBuzzCounterComponent";

export default class FizzBuzzView {
  constructor() {
    this._service = new FizzBuzzApiService();
    this._counterComponent = new FizzBuzzCounterComponent(this._service);
    this._tableComponent = new FizzBuzzTableComponent(this._service);
  }

  render() {
    const result = `
              <div class="py-3">
                <section id="menu">
                  <div class="container">
                    <div id="app__message"></div>
                    <div class="nav nav-tabs" id="tab-menus" role="tablist">
                      <a
                        aria-controls="panel-menu01"
                        aria-selected="true"
                        class="nav-item nav-link active"
                        data-toggle="tab"
                        href="#panel-menu01"
                        id="tab-menu01"
                        role="tab"
                        >Counter</a
                      >
                      <a
                        aria-controls="panel-menu02"
                        aria-selected="false"
                        class="nav-item nav-link"
                        data-toggle="tab"
                        href="#panel-menu02"
                        id="tab-menu02"
                        role="tab"
                        >Table</a
                      >
                    </div>

                    <div class="tab-content" id="panel-menus">
                      <div
                        aria-labelledby="tab-menu01"
                        class="tab-pane fade show active border border-top-0 jumbotron"
                        id="panel-menu01"
                        role="tabpanel"
                      >
                        <div id="app__counter" class="row d-flex align-items-center">
                        </div>
                      </div>
                      <div
                        aria-labelledby="tab-menu02"
                        class="tab-pane fade border border-top-0"
                        id="panel-menu02"
                        role="tabpanel"
                      >
                        <dvi class="row p-3">
                          <div id="app__table" class="col-md-12 order-md-2">
                          </div>
                        </dvi>
                      </div>
                    </div>
                  </div>
                </section>
              </div>
            `;

    document.querySelector("#app-fizz-buzz").innerHTML = result;
    this._counterComponent.render();
    this._tableComponent.render();
  }
}
