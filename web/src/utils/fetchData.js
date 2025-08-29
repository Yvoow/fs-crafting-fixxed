export const fetchData = async (event, data) => {
  try {
    let response;
    
    if (data) {
      // POST request if data is provided
      response = await fetch(`https://${GetParentResourceName()}/${event}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify(data),
      });
    } else {
      // GET request if no data is provided
      response = await fetch(`https://${GetParentResourceName()}/${event}`);
    }
    
    const responseData = await response.json();
    return responseData;
  } catch (error) {
    console.error('Error in fetchData:', error);
    return { error: 'Failed to reach server' };
  }
};