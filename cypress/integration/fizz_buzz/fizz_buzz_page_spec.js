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
      cy.get('#increment').click();
      cy.get('#increment').click();
      cy.get('#increment').click();
      cy.get(".display-1").should("contain", "Fizz");
    });

    it("デクリメントすると値が変わる", () => {
      cy.get('#decrement').click();
      cy.get('#decrement').click();
      cy.get(".display-1").should("contain", "1");
    });
  });
});
