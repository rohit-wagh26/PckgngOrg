import { LightningElement, api, wire, track } from 'lwc';
import getOpportunities from '@salesforce/apex/FMDashboardController.getOpportunityCount';
import APEXCHARTS from '@salesforce/resourceUrl/apexchartJs';
import HIGHCHARTS from '@salesforce/resourceUrl/highchartsJs';
import { loadScript } from 'lightning/platformResourceLoader';

export default class FmSalesPipeline extends LightningElement {

  @api filteredSalesRepProfiles;

  opportunityData;
  amount = false;
  chart;
  chart2;
  agingchart;
  @track selectedFilter = 'Opportunity Count By Stage';
  @track filterOptions = [
    { label: 'Opportunity Count By Stage', value: 'Opportunity Count By Stage' },
    { label: 'Opportunity Value By Stage', value: 'Opportunity Value By Stage' }
  ];

  @wire(getOpportunities, { salesRepProfiles: '$filteredSalesRepProfiles' })
  wiredOpportunityData({ error, data }) {
    if (data) {
      this.opportunityData = data;
      console.log('this.opportunityData' + this.opportunityData);

      loadScript(this, HIGHCHARTS)
        .then(() => {
          this.initializeChart();
        })
        .catch(error => {
          console.log('Error loading ApexCharts.js', error);
        });

      //this.initializeChart();
    } else if (error) {
      console.error('Error retrieving Opportunity data', error);
    }
  }

  handleFilterChange(event) {
    this.selectedFilter = event.detail.value;
    this.initializeChart(); // Implement this function to update the chart based on filters
  }



  initializeChart() {

    const labels = [];
    const series = [];
    console.log('selectedFilter' + this.selectedFilter);
    this.opportunityData.forEach(item => {
      labels.push(item['StageName']);
      if (this.selectedFilter == 'Opportunity Count By Stage') {
        series.push(item['oppCount']);
      }
      else {
        series.push(item['totalAmount']);
      }
      
    });


    const chartOptions = {
      chart: {
        type: 'bar', // Specify the chart type (e.g., bar, pie, line)
        height: 400, // Set the chart height
        width: 1100,
        horizontal: true,
        // Add other chart-specific options here
        toolbar: {
          show: true
        },
        zoom: {
          enabled: true
        }
      },
      xaxis: {
        categories: this.opportunityData.map(item => item['StageName']),
        labels: {
          rotate: 0, // Rotate x-axis labels for better readability
        },
        title: {
          text: 'Number of Opportunities', // Add a y-axis title
        },
      },
      yaxis: {
        title: {
          text: 'Sale Stages', // Add a y-axis title
        },
      },
      legend: {
        position: 'right',
        offsetY: 40
      },
      fill: {
        opacity: 1
      },
      responsive: [{
        breakpoint: 480,
        options: {
          legend: {
            position: 'bottom',
            offsetX: -10,
            offsetY: 0
          }
        }
      }], series: [{

        data: series,
      }],
      plotOptions: {
        bar: {
          horizontal: true, // Set to true for horizontal bars
        },
      },
    };

    const agingChartOptions2 = {
      chart: {
        type: 'bar', // Specify the chart type (e.g., bar, pie, line)
        height: 400, // Set the chart height
        width: 1100,

        // Add other chart-specific options here
        toolbar: {
          show: true
        },
        zoom: {
          enabled: true
        }
      },
      xxis: {
        categories: this.opportunityData.map(item => item['StageName']),
        labels: {
          rotate: 0, // Rotate x-axis labels for better readability
        },
        title: {
          text: 'Sale Stages', // Add a y-axis title
        },
      },
      yaxis: {
        title: {
          text: 'Number of Opportunities', // Add a y-axis title
        },
      },
      legend: {
        position: 'right',
        offsetY: 40
      },
      fill: {
        opacity: 1
      },
      responsive: [{
        breakpoint: 480,
        options: {
          legend: {
            position: 'bottom',
            offsetX: -10,
            offsetY: 0
          }
        }
      }], series: [{

        data: series,
      }],

    };

    const agingChartOptions = {
      chart: {
        type: 'bar', // Specify the chart type (e.g., bar, pie, line)
        height: 400, // Set the chart height
        width: 1100,

        // Add other chart-specific options here
        toolbar: {
          show: true
        },
        zoom: {
          enabled: true
        }
      },
      title: {
        text: 'Pipeline Opportunities by Stage', // Set the chart title
        align: 'left'
      },
      xAxis: {
        categories: this.opportunityData.map(item => item['StageName']),

        title: {
          text: 'Sale Stages', // Add a y-axis title
        },
      },
      yAxis: {
        title: {
          text: 'Number of Opportunities', // Add a y-axis title
        },
      },
      legend: {
        enabled: true,
      },
      fill: {
        opacity: 1
      },
      responsive: [{
        breakpoint: 480,
        options: {
          legend: {
            position: 'bottom',
            offsetX: -10,
            offsetY: 0
          }
        }
      }], series: [{

        data: series,
      }],

    };
    // Create and configure your ApexCharts instance here
    // this.chart2 = new ApexCharts(this.template.querySelector('.chart2'), agingChartOptions

    // );  

    //this.agingchart = new ApexCharts(this.template.querySelector('.agingchart'), agingChartOptions

    //);

      if (this.selectedFilter == 'Opportunity Value By Stage') {
        console.log('inside if' );
        agingChartOptions.yAxis.title = 'Amount';

    } 
    Highcharts.chart(this.template.querySelector('.chart'), agingChartOptions);

    //this.agingchart.render();
    //this.chart2.render();
  }


}