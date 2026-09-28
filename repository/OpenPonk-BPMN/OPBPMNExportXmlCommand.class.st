"
A model command that serializes the active BPMN collaboration model into standard BPMN 2.0 XML format.
"
Class {
	#name : 'OPBPMNExportXmlCommand',
	#superclass : 'OPBPMNCommand',
	#category : 'OpenPonk-BPMN-Commands',
	#package : 'OpenPonk-BPMN',
	#tag : 'Commands'
}

{ #category : 'activation' }
OPBPMNExportXmlCommand class >> modelMenuActivation [
	<classAnnotation>
	^ OPModelMenuActivation
		byItemOf: OPModelBasicMenuGroup
		order: 30
		for: OPEditor
]

{ #category : 'accessing' }
OPBPMNExportXmlCommand >> defaultMenuIcon [
	"Answers the icon form for the export command."
	^ OPBPMNIcon current logo
]

{ #category : 'accessing' }
OPBPMNExportXmlCommand >> defaultMenuItemName [
	"Answers the display name of the export command."
	^ 'Export as XML...'
]

{ #category : 'execution' }
OPBPMNExportXmlCommand >> execute [
	"Exports the BPMN package to an XML file."
	OPBPMNPlugin exportPackage: self diagramController
]
