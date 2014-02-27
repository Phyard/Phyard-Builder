
public function OnGlobalSocketMessage (message:String):void
{
   //var valueSource1:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClasses.kNumberClassDefinition, 0, valueSource2);
   var valueSource0:Parameter_DirectConstant = new Parameter_DirectConstant (CoreClasses.kStringClassDefinition, message); //, valueSource1);
   var valueSourceList:Parameter = valueSource0;
   
   HandleEventById (CoreEventIds.ID_OnPlayerActionData, valueSourceList);
}
