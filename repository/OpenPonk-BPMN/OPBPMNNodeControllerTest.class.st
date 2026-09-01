"
I am an abstract base test class verifying common initialization, targeting, and rendering logic for generic BPMN node controllers.
"
Class {
	#name : 'OPBPMNNodeControllerTest',
	#superclass : 'OPAbstractElementControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'testing' }
OPBPMNNodeControllerTest class >> isAbstract [
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^ self = OPBPMNNodeControllerTest
]

{ #category : 'constants' }
OPBPMNNodeControllerTest >> diagramControllerClass [

	^ OPBPMNDiagramController
]

{ #category : 'constants' }
OPBPMNNodeControllerTest >> diagramModelClass [

	^ OPBPMNModel
]
