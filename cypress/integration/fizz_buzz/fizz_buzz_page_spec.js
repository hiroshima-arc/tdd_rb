/* eslint-disable no-undef */
describe("FizzBuzz Page", () => {
  it("successfully loads", () => {
    cy.wait(1000);
    cy.visit("http://localhost:3000"); // change URL to match your dev URL
  });

  it("機能名が表示される", () => {
    cy.get("#app > :nth-child(1) > :nth-child(1)").should(
      "contain",
      "FizzBuzz"
    );
  });

  describe("カウンター画面", () => {
    beforeEach(() => {
      cy.get("#tab-menu01").click();
    });

    it("初期値が表示される", () => {
      cy.get(".display-1").should("contain", "FizzBuzz");
    });

    it("インクリメントすると値が変わる", () => {
      cy.get("#increment").click();
      cy.get("#increment").click();
      cy.get("#increment").click();
      cy.get(".display-1").should("contain", "Fizz");
    });

    it("デクリメントすると値が変わる", () => {
      cy.get("#decrement").click();
      cy.get("#decrement").click();
      cy.get(".display-1").should("contain", "1");
    });
  });

  describe("一覧編集画面", () => {
    beforeEach(() => {
      cy.get("#tab-menu02").click();
    });

    describe("表示する", () => {
      describe("タイプ1を選択した場合", () => {
        it("通常パターンが表示される", () => {
          cy.get('#app__select--type').select("タイプ1")
          cy.get("tbody > :nth-child(1) > :nth-child(3)").should(
            "contain",
            "Fizz"
          );
        });
      });

      describe("タイプ2を選択した場合", () => {
        it("数字のみのパターンが表示される", () => {
          cy.get('#app__select--type').select("タイプ2")
          cy.get("tbody > :nth-child(1) > :nth-child(3)").should(
            "contain",
            "3"
          );
        });
      });

      describe("タイプ3を選択した場合", () => {
        it("FizzBuzzのみのパターンが表示される", () => {
          cy.get('#app__select--type').select("タイプ3")
          cy.get("tbody > :nth-child(2) > :nth-child(5)").should(
            "contain",
            "FizzBuzz"
          );
        });
      });
    });
  });
});
