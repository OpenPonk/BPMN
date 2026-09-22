"
I provide executable example models and diagram setups for the OpenPonk BPMN editor. I demonstrate complete and valid business process scenarios containing pools, events, gateways, activities, sub-processes, data objects, annotations, and directional flows.
"
Class {
	#name : 'OPBPMNExamples',
	#superclass : 'Object',
	#category : 'OpenPonk-BPMN-Examples',
	#package : 'OpenPonk-BPMN',
	#tag : 'Examples'
}

{ #category : 'accessing' }
OPBPMNExamples class >> emptyModel [
	"Answers a newly initialized, empty BPMN process model."

	^ OPBPMNModel new
		name: 'New BPMN Model';
		yourself
]

{ #category : 'accessing' }
OPBPMNExamples class >> exampleOrderFulfillment [
	"Answers a valid, fully connected BPMN model containing all 15 supported modeling constructs."

	| model poolCustomer poolVendor startEvent taskCheckStock gatewayInStock procureSubProcess taskOrderSupplier boundaryTimer collapsedSubProcess intermediateTimer endEventFulfilled endEventCanceled dataObjectOrder annotationSla flowStartToTask flowTaskToGateway flowGatewayToProcure flowGatewayToShip flowProcureToShip flowBoundaryToCancel flowShipToIntermediate flowIntermediateToEnd messageFlow dataFlow association |
	model := self emptyModel.
	model name: 'Order Fulfillment'.
	poolCustomer := OPBPMNPoolModel new
		name: 'Customer';
		lanes: 0;
		yourself.
	poolVendor := OPBPMNPoolModel new
		name: 'Order Fulfillment';
		lanes: 2;
		laneNames: { 'Sales' . 'Warehouse' };
		yourself.
	model
		add: poolCustomer;
		add: poolVendor.
	startEvent := OPBPMNStartEventModel new
		name: 'Order Placed';
		type: OPBPMNNodeType Receive;
		yourself.
	taskCheckStock := OPBPMNActivityModel new
		name: 'Check Stock';
		type: OPBPMNNodeType User;
		yourself.
	gatewayInStock := OPBPMNGatewayModel new
		name: 'In Stock?';
		type: OPBPMNNodeType Exclusive;
		yourself.
	procureSubProcess := OPBPMNSubProcessModel new
		name: 'Procure Items';
		yourself.
	taskOrderSupplier := OPBPMNActivityModel new
		name: 'Order from Vendor';
		type: OPBPMNNodeType Service;
		executableAttribute: 'vendorApi';
		executableAttributeValue: 'postPurchaseOrder';
		yourself.
	procureSubProcess add: taskOrderSupplier.
	boundaryTimer := OPBPMNBoundaryEventModel new
		name: '2 Days SLA';
		type: OPBPMNNodeType Timer;
		isNonInterrupting: false;
		yourself.
	procureSubProcess add: boundaryTimer.
	collapsedSubProcess := OPBPMNCollapsedSubProcessModel new
		name: 'Prepare Shipment';
		type: OPBPMNNodeType None;
		yourself.
	intermediateTimer := OPBPMNIntermediateEventModel new
		name: 'Wait for Carrier';
		type: OPBPMNNodeType Timer;
		timerType: #timeDuration;
		timerValue: 'PT2H';
		yourself.
	endEventFulfilled := OPBPMNEndEventModel new
		name: 'Order Delivered';
		type: OPBPMNNodeType None;
		yourself.
	endEventCanceled := OPBPMNEndEventModel new
		name: 'Order Canceled';
		type: OPBPMNNodeType Error;
		yourself.
	dataObjectOrder := OPBPMNDataObjectModel new
		name: 'Order Details';
		type: OPBPMNNodeType DataObject;
		yourself.
	annotationSla := OPBPMNAnnotationModel new
		text: 'Standard fulfillment SLA: 48 hours';
		yourself.
	poolVendor
		add: startEvent;
		add: taskCheckStock;
		add: gatewayInStock;
		add: procureSubProcess;
		add: collapsedSubProcess;
		add: intermediateTimer;
		add: endEventFulfilled;
		add: endEventCanceled;
		add: dataObjectOrder;
		add: annotationSla.
	flowStartToTask := (OPBPMNFlowModel from: startEvent to: taskCheckStock)
		name: String empty;
		type: 'Normal';
		yourself.
	startEvent addFlow: flowStartToTask.
	taskCheckStock addFlow: flowStartToTask.
	flowTaskToGateway := (OPBPMNFlowModel from: taskCheckStock to: gatewayInStock)
		name: String empty;
		type: 'Normal';
		yourself.
	taskCheckStock addFlow: flowTaskToGateway.
	gatewayInStock addFlow: flowTaskToGateway.
	flowGatewayToProcure := (OPBPMNFlowModel from: gatewayInStock to: procureSubProcess)
		name: 'Out of Stock';
		type: 'Conditional';
		yourself.
	gatewayInStock addFlow: flowGatewayToProcure.
	procureSubProcess addFlow: flowGatewayToProcure.
	flowGatewayToShip := (OPBPMNFlowModel from: gatewayInStock to: collapsedSubProcess)
		name: 'In Stock';
		type: 'Default';
		yourself.
	gatewayInStock addFlow: flowGatewayToShip.
	collapsedSubProcess addFlow: flowGatewayToShip.
	flowProcureToShip := (OPBPMNFlowModel from: procureSubProcess to: collapsedSubProcess)
		name: 'Procured';
		type: 'Normal';
		yourself.
	procureSubProcess addFlow: flowProcureToShip.
	collapsedSubProcess addFlow: flowProcureToShip.
	flowBoundaryToCancel := (OPBPMNFlowModel from: boundaryTimer to: endEventCanceled)
		name: 'SLA Breach';
		type: 'Normal';
		yourself.
	boundaryTimer addFlow: flowBoundaryToCancel.
	endEventCanceled addFlow: flowBoundaryToCancel.
	flowShipToIntermediate := (OPBPMNFlowModel from: collapsedSubProcess to: intermediateTimer)
		name: String empty;
		type: 'Normal';
		yourself.
	collapsedSubProcess addFlow: flowShipToIntermediate.
	intermediateTimer addFlow: flowShipToIntermediate.
	flowIntermediateToEnd := (OPBPMNFlowModel from: intermediateTimer to: endEventFulfilled)
		name: String empty;
		type: 'Normal';
		yourself.
	intermediateTimer addFlow: flowIntermediateToEnd.
	endEventFulfilled addFlow: flowIntermediateToEnd.
	messageFlow := (OPBPMNMessageFlowModel from: poolCustomer to: startEvent)
		name: 'Place Order';
		yourself.
	poolCustomer addFlow: messageFlow.
	startEvent addFlow: messageFlow.
	dataFlow := (OPBPMNDataFlowModel from: dataObjectOrder to: taskCheckStock)
		name: 'Order Info';
		yourself.
	dataObjectOrder addFlow: dataFlow.
	taskCheckStock addFlow: dataFlow.
	association := OPBPMNAssociationModel new
		source: annotationSla;
		target: taskCheckStock;
		associationDirection: OPBPMNAssociationModel associationDirectionNone;
		yourself.
	annotationSla addAssociation: association.
	taskCheckStock addAssociation: association.
	^ model
]

{ #category : 'examples' }
OPBPMNExamples class >> openExample: aModel [
	"Opens the given BPMN model in a newly created OpenPonk workbench and lays out all elements."

	| project |
	project := OPProject named: 'BPMN Example'.
	project addModel: aModel.
	^ (OPWorkbench openProject: project) showAllElementsInAllDiagrams
]

{ #category : 'examples' }
OPBPMNExamples class >> openExampleEmptyModel [
	"Creates and opens an empty BPMN diagram in workbench."

	<example>
	^ self openExample: self emptyModel
]

{ #category : 'examples' }
OPBPMNExamples class >> openExampleOrderFulfillment [
	"Creates and opens the comprehensive Order Fulfillment BPMN example in workbench."

	<example>
	^ self openExample: self exampleOrderFulfillment
]
