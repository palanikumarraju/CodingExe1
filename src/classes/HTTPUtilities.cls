/**
 * Created by Palanikumar.Raju on 23/01/2020.
 * Description: Generic helper class to post given payload to given endpoint
 */

public class HTTPUtilities
{
	// Post to endpoint
	public static Integer postData(String endPoint, String jsonData)
	{
		try
		{
			HttpRequest request = new HttpRequest();
			request.setEndpoint(endPoint);
			request.setMethod('POST');
			request.setHeader('Content-Type', 'application/json;charset=UTF-8');

			request.setBody(jsonData);
			Http http = new Http();
			HttpResponse response = http.send(request);
			return response.getStatusCode();
		}
		catch(Exception expection)
		{
			throw expection;
		}
	}
}