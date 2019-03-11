describe('My First Test', function() {
  it('Visits kube 4 dogs', function() {
    cy.visit('https://kubernetesfordogs.com');

		cy.contains('k8s for k9s');
  });
});
