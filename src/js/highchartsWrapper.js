// Internal JS function
function renderChartInternal(targetID, title, xLabel, yLabel, categories, values) {
  new Highcharts.Chart({
       chart: {
          renderTo: targetID,
          defaultSeriesType: 'column',
          margin: [50, 50, 150, 80]
       },
       title: {
          text: title
       },
       xAxis: {
          categories: categories,
          labels: {
                  rotation: -90,
                  align: 'right',
                  style: {
                      font: 'normal 12px Verdana, sans-serif',
                      color: '#000000'
                  }
          }
       },
       yAxis: {
          title: {
             min: 0,
             text: yLabel

          },
          labels: {
              style: {
                  color: '#000000'
              }
          }
       },
       legend: {
              enabled: false
       },
       series: [{
          name: xLabel,
          data: values
       }]
  });
}

// Exposed to Links
function _renderChart(targetDiv, title, xLabel, yLabel, data) {
  const dataList = LINKEDLIST.toArray(data);
  const xAxis = dataList.map(x => x[1]);
  const yAxis = dataList.map(x => x[2]);
  renderChartInternal(targetDiv, title, xLabel, yLabel, xAxis, yAxis);
}
const renderChart = LINKS.kify(_renderChart);
