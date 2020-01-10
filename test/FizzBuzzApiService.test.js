const chai = require("chai");
const assert = chai.assert;
const FizzBuzzApiService = require("../src/presentation/FizzBuzzApiService").default

suite("FizzBuzzApiServiceTest", () => {
  let apiService;
  setup("前準備", () => {
    apiService = new FizzBuzzApiService();
  });

  suite("GenerateApiService", () => {
    test("3を渡したらJSONオブジェクトを返す", () => {
      return apiService.generate(3).then(data => {
        assert.deepEqual({ number: 3, value: "Fizz" }, data);
      });
    });

    test("5を渡したらJSONオブジェクトを返す", () => {
      return apiService.generate(5).then(data => {
        assert.deepEqual({ number: 5, value: "Buzz" }, data);
      });
    });

    test("15を渡したらJSONオブジェクトを返す", () => {
      return apiService.generate(15).then(data => {
        assert.deepEqual({ number: 15, value: "FizzBuzz" }, data);
      });
    });
  });

  suite("GenerateListApiService", () => {
    suite("タイプ1の場合", () => {
      test("100件のJSONオブジェクトを返す", () => {
        return apiService.generateList(1).then(json => {
          assert.equal(100, json.data.length);
        });
      });

      test("最初の値は1", () => {
        return apiService.generateList(1).then(json => {
          assert.equal("1", json.data[0]);
        });
      });

      test("最後の値はBuzz", () => {
        return apiService.generateList(1).then(json => {
          assert.equal("Buzz", json.data[99]);
        });
      });

      test("14番目の値はFizzBuzz", () => {
        return apiService.generateList(1).then(json => {
          assert.equal("FizzBuzz", json.data[14]);
        });
      });
    });

    suite("タイプ2の場合", () => {
      test("最初の値は1", () => {
        return apiService.generateList(2).then(json => {
          assert.equal("1", json.data[0]);
        });
      });

      test("最後の値は100", () => {
        return apiService.generateList(2).then(json => {
          assert.equal("100", json.data[99]);
        });
      });

      test("14番目の値は15", () => {
        return apiService.generateList(2).then(json => {
          assert.equal("15", json.data[14]);
        });
      });
    });

    suite("タイプ3の場合", () => {
      test("最初の値は1", () => {
        return apiService.generateList(3).then(json => {
          assert.equal("1", json.data[0]);
        });
      });

      test("最後の値は100", () => {
        return apiService.generateList(3).then(json => {
          assert.equal("100", json.data[99]);
        });
      });

      test("14番目の値はFizzBuzz", () => {
        return apiService.generateList(3).then(json => {
          assert.equal("FizzBuzz", json.data[14]);
        });
      });
    });
  });
});
