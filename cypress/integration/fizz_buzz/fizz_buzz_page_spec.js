/* eslint-disable no-undef */
describe("FizzBuzz Page", () => {
  it("successfully loads", () => {
    cy.wait(1000);
    cy.visit("http://localhost:3000"); // change URL to match your dev URL
  });

  it("機能名が表示される", () => {
    cy.get('#app > :nth-child(1) > :nth-child(1)').should("contain", "FizzBuzz");
  });
});
