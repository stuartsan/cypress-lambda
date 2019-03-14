describe("My First Test", function() {
  it("Visits prisonstudies project", function() {
    cy.visit("https://stuartsan.github.io/prisonstudies");

    cy.contains("Prison Data");
  });
});
