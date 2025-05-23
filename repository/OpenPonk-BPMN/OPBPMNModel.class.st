Class {
	#name : 'OPBPMNModel',
	#superclass : 'OPModelObject',
	#instVars : [
		'isExecutable',
		'profileApplications'
	],
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'accessing' }
OPBPMNModel >> edges [
	^ elements select: #isEdge
]

{ #category : 'accessing' }
OPBPMNModel >> initialize [
	super initialize.
	isExecutable := false.
]

{ #category : 'accessing' }
OPBPMNModel >> isExecutable [ 
	^ isExecutable
]

{ #category : 'accessing' }
OPBPMNModel >> isExecutable: aBoolean [
	isExecutable := aBoolean 
]

{ #category : 'accessing' }
OPBPMNModel >> nodes [
	^ elements select: #isNode
]

{ #category : 'accessing' }
OPBPMNModel >> printType [
	^ 'process'
]

{ #category : 'accessing' }
OPBPMNModel >> profileApplications [
	"References the ProfileApplications that indicate which profiles have been applied to the Package."
	^ profileApplications ifNil: [ self edges ]
]

{ #category : 'accessing' }
OPBPMNModel >> profileApplications: aProfileApplication [
	"References the ProfileApplications that indicate which profiles have been applied to the Package."
	self profileApplications
		removeAll;
		addAll: aProfileApplication
]
