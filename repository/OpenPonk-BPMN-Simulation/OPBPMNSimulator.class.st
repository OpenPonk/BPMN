Class {
	#name : 'OPBPMNSimulator',
	#superclass : 'OPDiagramSimulator',
	#instVars : [
		'configurableGateways'
	],
	#category : 'OpenPonk-BPMN-Simulation-Simulation',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Simulation'
}

{ #category : 'initialization' }
OPBPMNSimulator class >> initialClassMapping [

	^ super initialClassMapping
		  at: OPBPMNDataFlowModel put: OPBPMNDataFlowSimulator;
		  at: OPBPMNFlowModel put: OPBPMNSequenceFlowSimulator;
		  at: OPBPMNMessageFlowModel put: OPBPMNMessageFlowSimulator;
		  at: OPBPMNBoundaryEventModel put: OPBPMNBoundaryEventSimulator;
		  at: OPBPMNDataObjectModel put: OPBPMNDataObjectSimulator;
		  at: OPBPMNActivityModel put: OPBPMNActivitySimulator;
		  at: OPBPMNCollapsedSubProcessModel
		  put: OPBPMNCollapsedSubProcessSimulator;
		  at: OPBPMNEndEventModel put: OPBPMNEndEventSimulator;
		  at: OPBPMNIntermediateEventModel
		  put: OPBPMNIntermediateEventSimulator;
		  at: OPBPMNStartEventModel put: OPBPMNStartEventSimulator;
		  at: OPBPMNGatewayModel put: OPBPMNGatewaySimulator;
		  at: OPBPMNSubProcessModel put: OPBPMNSubProcessSimulator;
		  at: OPBPMNPoolModel put: OPBPMNPoolSimulator;
		  yourself
]

{ #category : 'accessing' }
OPBPMNSimulator >> configurableGateways [

	^ configurableGateways
]

{ #category : 'initialization' }
OPBPMNSimulator >> initialize [

	super initialize.
	configurableGateways := OrderedCollection new
]

{ #category : 'private - creation' }
OPBPMNSimulator >> loadConfigurableGateways [
	"selects elements which are configurable gateways"

	configurableGateways := elements select: [ :element |
		                        element isGateway and:
			                        element isConfigurable ]
]

{ #category : 'private - creation' }
OPBPMNSimulator >> loadItems [
	"creates simulators for model elements"

	super loadItems.
	self loadConfigurableGateways 
]

{ #category : 'stepping' }
OPBPMNSimulator >> setDefaultStepping [
	"sets default stepping settings"

	super setDefaultStepping.
	self
		fromSteppableElements;
		orderByPriority;
		selectAll;
		resetActions;
		addAction: [ :item | item step ]
]
