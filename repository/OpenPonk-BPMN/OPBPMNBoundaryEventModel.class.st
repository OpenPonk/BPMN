Class {
	#name : 'OPBPMNBoundaryEventModel',
	#superclass : 'OPBPMNNodeModel',
	#instVars : [
		'subscribeDiagram',
		'isNonInterrupting'
	],
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'accessing' }
OPBPMNBoundaryEventModel >> @ aName [

	^ self nodeNamed: aName
]

{ #category : 'accessing' }
OPBPMNBoundaryEventModel >> changed [

	super changed.
	owner changed
]

{ #category : 'accessing' }
OPBPMNBoundaryEventModel >> defaultType [

	^ OPBPMNNodeType Error
]

{ #category : 'accessing' }
OPBPMNBoundaryEventModel >> initialize [ 
	super initialize.
	isNonInterrupting := false.
]

{ #category : 'accessing' }
OPBPMNBoundaryEventModel >> isNonInterrupting [
	^ isNonInterrupting 
]

{ #category : 'accessing' }
OPBPMNBoundaryEventModel >> isNonInterrupting: aValue [
	isNonInterrupting := aValue. 
]

{ #category : 'accessing' }
OPBPMNBoundaryEventModel >> nodeNamed: aName [

	^ self elementNamed: aName
]

{ #category : 'accessing' }
OPBPMNBoundaryEventModel >> printType [

	^ 'boundary'
]

{ #category : 'accessing' }
OPBPMNBoundaryEventModel >> subscribeDiagram [

	^ subscribeDiagram
]

{ #category : 'accessing' }
OPBPMNBoundaryEventModel >> subscribeDiagram: aDiagram [

	subscribeDiagram := aDiagram
]

{ #category : 'accessing' }
OPBPMNBoundaryEventModel >> typeIconFor: aType [

	aType = OPBPMNNodeType Receive ifTrue: [ 
		^ OPBPMNIcon current activityReceiveSquare ].
	aType = OPBPMNNodeType Timer ifTrue: [ 
		^ OPBPMNIcon current eventTimer ].
	aType = OPBPMNNodeType Escalation ifTrue: [ 
		^ OPBPMNIcon current eventEscalation ].
	aType = OPBPMNNodeType Conditional ifTrue: [ 
		^ OPBPMNIcon current eventCondition ].
	aType = OPBPMNNodeType Error ifTrue: [ 
		^ OPBPMNIcon current eventError ].
	aType = OPBPMNNodeType Cancel ifTrue: [ 
		^ OPBPMNIcon current eventCancel ].
	aType = OPBPMNNodeType Compensation ifTrue: [ 
		^ OPBPMNIcon current eventCompensation ].
	aType = OPBPMNNodeType Signal ifTrue: [ 
		^ OPBPMNIcon current eventSignal ].
	aType = OPBPMNNodeType Multiple ifTrue: [ 
		^ OPBPMNIcon current eventMultiple ].
	aType = OPBPMNNodeType ParallelMultiple ifTrue: [ 
		^ OPBPMNIcon current eventParallelMultiple ].
	aType = OPBPMNNodeType CatchCompensation ifTrue: [ 
		^ OPBPMNIcon current eventCatchCompensation ]
]
