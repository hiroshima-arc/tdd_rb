export default class FizzBuzzTableComponent {
  constructor(service) {
    this._service = service;
    this._list = [];
    this._type = 1;
  }

  selectEvent(e) {
    this._type = e.target.value;
    this.render();
  }

  render() {
    this._service.generateList(this._type).then(json => {
      this._list = json.data;

      const result = (() => {
        const select = (() => {
          const type1 = `<option value="1">タイプ1</option>`;
          const type2 =
            this._type === "2"
              ? `<option value="2" selected>タイプ2</option>`
              : `<option value="2">タイプ2</option>`;
          const type3 =
            this._type === "3"
              ? `<option value="3" selected>タイプ3</option>`
              : `<option value="3">タイプ3</option>`;

          return `
                    <select
                      name="type"
                      id="app__select--type"
                      class="browser-default custom-select"
                    >
                      ${type1}
                      ${type2}
                      ${type3}
                    </select>
              `;
        })();

        const table = (() => {
          // 0から始まるので最初の値を削除する
          const th = [...Array(11).keys()].slice(1).map(i => `<th>${i}</th>`);

          const td = (() => {
            let row = [];
            let column = [];
            this._list.forEach((v, k) => {
              column.push(`<td>${v}</td>`);

              if ((k + 1) % 10 === 0) {
                row.push(column.join(""));
                column = [];
              }
            });

            return row;
          })();

          return `
                      <table class="table table-striped">
                        <thead>
                          <tr>
                            ${th[0]}
                            ${th[1]}
                            ${th[2]}
                            ${th[3]}
                            ${th[4]}
                            ${th[5]}
                            ${th[6]}
                            ${th[7]}
                            ${th[8]}
                            ${th[9]}
                          </tr>
                        </thead>
                          <tbody>
                            <tr>${td[0]}</tr>
                            <tr>${td[1]}</tr>
                            <tr>${td[2]}</tr>
                            <tr>${td[3]}</tr>
                            <tr>${td[4]}</tr>
                            <tr>${td[5]}</tr>
                            <tr>${td[6]}</tr>
                            <tr>${td[7]}</tr>
                            <tr>${td[8]}</tr>
                            <tr>${td[9]}</tr>
                          </tbody>
                      </table>
                  `;
        })();

        return `
                <dvi class="row p-3">
                  <div class="col-md-12 order-md-2">
                    <div id="app__select">
                      ${select}
                    </div>
                    <div
                      class="table-responsive"
                      id="app__table-contents"
                    >
                     ${table}
                    </div>
                  </div>
                </dvi>
            `;
      })();

      document.querySelector("#app__table").innerHTML = result;
      document
        .querySelector("#app__select--type")
        .addEventListener("change", this.selectEvent.bind(this));
    });
  }
}
