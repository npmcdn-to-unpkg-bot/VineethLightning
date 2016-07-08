public with sharing class CB_CustomerDetailController {

	private final Contact customer;

	public CB_CustomerDetailController( ApexPages.StandardController stdController ) {
		this.customer = ( Contact )stdController.getRecord();
	}

}