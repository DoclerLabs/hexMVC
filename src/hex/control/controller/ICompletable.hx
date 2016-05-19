package hex.control.controller;

/**
 * @author Francis Bourre
 */
interface ICompletable<ResultType>
{
	function onComplete( callback : ResultType->Void ) : ICompletable<ResultType>;
	function onFail( callback : String->Void ) : ICompletable<ResultType>;
}