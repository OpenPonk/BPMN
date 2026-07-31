Class {
	#name : 'OPBPMNEdgeControllerTest',
	#superclass : 'OPAbstractDirectionalRelationshipControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'testing' }
OPBPMNEdgeControllerTest class >> isAbstract [
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^ self = OPBPMNEdgeControllerTest
]

{ #category : 'constants' }
OPBPMNEdgeControllerTest >> diagramControllerClass [

	^ OPBPMNDiagramController
]

{ #category : 'constants' }
OPBPMNEdgeControllerTest >> diagramModelClass [

	^ OPBPMNModel
]
